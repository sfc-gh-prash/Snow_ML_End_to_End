import React from 'react';

const StrategicEvolutionPlan = () => {
  const stages = [
    {
      title: '30 Days',
      color: 'bg-blue-700',
      headline: 'Foundation & Learning',
      items: [
        'Deep Platform Understanding',
        'Comprehensive Maturity Model Exploration',
        'Skill Development & Training',
        'Initial Customer Landscape Mapping',
        'Cross-Functional Team Alignment'
      ]
    },
    {
      title: '60 Days',
      color: 'bg-teal-700',
      headline: 'Strategic Positioning',
      items: [
        'Strategic Account Identification',
        'Customized Engagement Blueprints',
        'Technical Discovery Acceleration',
        'Performance Metric Frameworks',
        'Opportunity Pipeline Development',
        'Collateral & Asset Creation'
      ]
    },
    {
      title: '90 Days',
      color: 'bg-emerald-800',
      headline: 'Transformational Impact',
      items: [
        'Proof of Concept Implementation',
        'Scalable Opportunity Expansion',
        'Comprehensive Feedback Integration',
        'Strategic Partner Ecosystem Building',
        'Industry-Specific Solution Refinement'
      ]
    }
  ];

  return (
    <div className="max-w-6xl mx-auto p-8 bg-gray-50">
      <h1 className="text-4xl font-bold text-center mb-10 text-gray-800">
        Strategic Growth Trajectory
      </h1>
      <div className="flex items-stretch w-full shadow-2xl rounded-xl overflow-hidden">
        {stages.map((stage, index) => (
          <div 
            key={stage.title} 
            className={`
              relative flex-1 p-6 text-white 
              ${stage.color}
              ${index < stages.length - 1 ? 'arrow-right' : ''}
            `}
            style={{
              clipPath: index < stages.length - 1 
                ? 'polygon(0 0, calc(100% - 30px) 0, 100% 50%, calc(100% - 30px) 100%, 0 100%)' 
                : 'polygon(0 0, 100% 0, 100% 100%, 0 100%)'
            }}
          >
            <div>
              <h2 className="text-2xl font-bold mb-2 pb-2 border-b border-white/30">
                {stage.title}
              </h2>
              <p className="text-sm mb-4 text-white/80 italic">
                {stage.headline}
              </p>
              <ul className="space-y-2">
                {stage.items.map((item, itemIndex) => (
                  <li 
                    key={itemIndex} 
                    className="text-sm flex items-start"
                  >
                    <svg 
                      className="w-4 h-4 mr-2 mt-1 opacity-70" 
                      fill="currentColor" 
                      viewBox="0 0 20 20"
                    >
                      <path 
                        fillRule="evenodd" 
                        d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-8.707l-3-3a1 1 0 00-1.414 1.414L10.586 9H7a1 1 0 100 2h3.586l-1.293 1.293a1 1 0 101.414 1.414l3-3a1 1 0 000-1.414z" 
                        clipRule="evenodd" 
                      />
                    </svg>
                    {item}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default StrategicEvolutionPlan;
